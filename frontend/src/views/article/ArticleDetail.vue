<template>
  <div class="article-detail" v-if="article">
    <vue-headful
      :title="title"
    />
    <div class="left-sidemenu" v-if="article">
      <ArticleDetailSideMenu :article="article" :sideMenu="sideMenu" />
    </div>
    <div class="article">
      <div class="nickname-keyword">
        <h1 class="detailTitle">{{ title }}</h1>
        <div class="keywords" style="margin-bottom : 1rem;">
          <div
            v-for="keyword in keywords"
            :key="keyword"
            class="keyword"
            @click="search(keyword)"
          >
            #{{ keyword }}
          </div>
        </div>
        <div class="username-date">
          <!-- @click="userToggle" -->
          <div>
            <span
              style="margin-right : 4px; cursor:pointer"
              @click="gotoWriterPage"
              id="nickname"
              >{{ nickname }}
            </span>
            <span v-if="ispublic == 3" style="color : gray;">비공개글 </span>
            <span v-if="isWriter">
              <Router-link
                :to="{
                  name: 'ArticleUpdate',
                  params: { id, keywords, title, content, ispublic },
                }"
              >
                <i
                  class="fas fa-edit"
                  style="cursor: pointer; margin-right : 4px; color : gray"
                ></i>
              </Router-link>
              <i
                class="fas fa-trash-alt"
                style="cursor: pointer; margin-right: 4px; color : gray"
                @click="removeArticle"
              ></i>
              <i
                class="fas fa-file-download"
                style="cursor: pointer; color : gray"
                @click="downloadFile"
              ></i>
            </span>
          </div>
          <span
            ><i class="fas fa-pen-nib" style="margin-right: 15px;">
              {{createdat}}{{ updatedAt }}
            </i>
            <i class="fas fa-eye"> {{ hits }}hits</i>
          </span>
        </div>
      </div>
      <div class="nickname-keyword markdown">
        <div id="viewer" />
      </div>
      <div class="nickname-keyword" v-if="article">
        <ArticleDetailProfile
          :article="article"
          :userImg="userImg"
          :userinfo="userinfo"
          :score="score"
        />
      </div>
      <div v-if="article" class="nickname-keyword">
        <div ref="comment">
          <CommentCreate
            :article="article"
            :commentList="sideMenu.commentList"
          />
        </div>
      </div>
      <button class="backBtn" @click="goback">뒤로가기</button>
    </div>
  </div>
</template>

<script>
import { fetchArticle, deleteArticle } from '../../api';
import '@toast-ui/editor/dist/toastui-editor-viewer.css';
import 'highlight.js/styles/github.css';
import Viewer from '@toast-ui/editor/dist/toastui-editor-viewer';
import codeSyntaxHightlight from '@toast-ui/editor-plugin-code-syntax-highlight';
import hljs from 'highlight.js';
import ArticleDetailSideMenu from '../../components/article/ArticleDetailSideMenu';
import ArticleDetailProfile from '../../components/article/ArticleDetailProfile';
import CommentCreate from '../../components/article/CommentCreate';
export default {
  name: 'ArticleDetail',
  components: {
    ArticleDetailSideMenu,
    ArticleDetailProfile,
    CommentCreate,
  },
  data() {
    return {
      id: this.$route.params.id,
      nickname: null,
      keywords: null,
      title: null,
      article: null,
      content: null,
      updatedAt: '',
      userinfo: null,
      userImg: null,
      ispublic: '',
      hits: 0,
      score: 0,
      sideMenu: {
        commentList: null,
        cntLikes: null,
        cntPin: null,
        isWriter: false,
      },
      isWriter: false,
    };
  },
  methods: {
    downloadFile() {
      const blob = new Blob([this.content], {type: 'text/plain'})
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = `${this.$store.state.nickname}_${this.title}.md`
      a.click()
      a.remove()
      window.URL.revokeObjectURL(url);
    },
    gotoWriterPage() {
      this.$router.push({
        name: 'Profile',
        params: { nickname: this.article.nickname },
      });
    },
    search(keyword) {
      const params = {
        q: keyword,
        category: 'keyword',
      };
      this.$router.push({ name: 'Dummy', params: { params } });
    },
    async getArticle() {
      try {
        const token = this.$store.state.id_token;
        const articleInfo = await fetchArticle(this.id, token);
        const {
          article,
          keyword,
          commentList,
          cntLikes,
          cntPin,
          userImg,
          userinfo,
          commentArticleCount,
          articleCount,
          ispublic,
          hits,
          score,
        } = articleInfo.data.object;
        this.article = article;

        this.keywords = keyword;
        this.nickname = article.nickname;
        this.title = article.title;
        this.content = article.content;

        this.sideMenu.commentList = commentList;
        this.sideMenu.cntLikes = cntLikes;
        this.sideMenu.cntPin = cntPin;
        this.userinfo = userinfo;
        this.userImg = userImg;
        this.commentArticleCount = commentArticleCount;
        this.articleCount = articleCount;
        this.ispublic = ispublic;
        this.hits = hits;
        this.score = score;

        this.createdat = '';
        for(let i =0;i<10;i++){
          this.createdat +=article.createdat[i]
        }
        if(article.updatedat != null){
          this.updatedAt = ' (' + this.$moment(article.updatedat).fromNow() + ' 수정)';
        }


        const loginUser = this.$store.state.nickname;
        if (this.article.nickname === loginUser) {
          this.isWriter = true;
        }
        return article.content;
      } catch (e) {
        this.$router.push({ name: 'NotFound' });
      }
    },
    getViewer() {
      this.getArticle().then((res) => {
        new Viewer({
          el: document.querySelector('#viewer'),
          initialValue: res,
          plugins: [[codeSyntaxHightlight, { hljs }]],
        });
      });
    },
    removeArticle() {
      const id_token = this.$store.state.id_token;

      deleteArticle(this.id, id_token)
        .then(() => this.$router.push('/latest'))
        .catch((err) => console.log(err));
    },
    goback() {
      this.$router.go(-1);
    },
  },
  mounted() {
    this.getViewer()
    console.log(this.$route)
    if (this.$route.params.at) {
      setTimeout(() => {
        const element = this.$refs['comment'];
        const top = element.offsetTop;
        window.scrollTo(0,top)
      },1000)
    }

  },
};
</script>

<style scoped>
.article-detail {
  display: flex;
  justify-content: space-around;
  margin-bottom: 2rem;
}
.article {
  padding-top: 135px;
  width: 80%;
  margin-right: 5%;
  /* margin-left: 5%; */
}
.nickname-keyword {
  padding: 1rem;
  margin-bottom: 1rem;
  background-color: white;
  border-radius: 10px;
}
.left-sidemenu {
  display: block;
}
#viewer {
  display: block;
  margin-bottom: 2rem;
}
.detailTitle {
  margin-bottom: 2%;
  font-size: 27px;
  /* margin-bottom: 1rem; */
}
.username-date {
  display: flex;
  justify-content: space-between;
  clear: both;
  font-size: 13px;
}
.username-date > span:nth-child(1) {
  font-weight: bold;
}
.keyword {
  float: left;
  margin-right: 5px;
  margin-bottom: 5px;
  padding: 5px;
  border-radius: 3px;
  color: white;
  background-color: #94adff;
  font-size: 14px;
  cursor: pointer;
}
.dropdown {
  padding: 3px;
  border: 1px solid black;
  margin-bottom: 1rem;
  width: 70px;
}
.dropdown > div {
  cursor: pointer;
}
.disabled {
  display: none;
}
#nickname {
  font-size: 16px;
}
@media (max-width: 414px) {
  .article-detail {
    padding: 1rem;
  }
  .left-sidemenu {
    display: block;
  }
  #viewer {
    display: block;
    margin-bottom: 2rem;
    overflow: auto;
  }
  .article {
    width: 100%;
  }
  .detailTitle {
    font-size: 20px;
  }
}
.backBtn {
  border-radius: 3px;
  color: white;
  background-color: #94adff;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 5px;
  width: 70px;
}
.commentBtn {
  border-radius: 3px;
  color: black;
  background-color: white;
  border: none;
  outline: none;
  cursor: pointer;
  padding: 5px;
}
</style>
