<template>
  <div id="example" style="padding-top: 40px">
    <vue-headful
      title="TWL: Today We Learned"
    />
    <div v-if="isLoading">
      <LoadingSpinner />
    </div>
    <div v-else style="margin-top: 100px">
      <div id="intro">
        <h1 style="font-size : 25px">HOT & RECOMMEND</h1>
        <p v-if="isLoggedIn" style="font-size : 14px;"><br>TWL에서 가장 트렌딩한 게시글과 회원님의 관심분야 인기글을 모아봤어요 </p>
        <p v-else style="font-size : 14px;"><br>TWL에서 가장 트렌딩한 게시글을 모아봤어요 </p>
      </div>
      <carousel-3d :controls-visible="true" :width="800" :height="carouselHeight" :display="5">
        <Slide v-for="(article, index) in articles" :index="index" :key="index">
          <ArticleCard
            style="margin : 0px"
            :article="article"
            :keywords="keywords[index]"
            :pinCnt="pinCntList[index]"
            :likesCnt="likesCntList[index]"
            :commentCnt="commentCntList[index]"
          />
        </Slide>
      </carousel-3d>
      <div id="outro">
        <div class="outro-text">
          Today We Learned에서 공부한 내용을 매일 가볍게 정리하고 팔로워들과
          공유하세요 !
        </div>
      </div>
    </div>
    <Footer />
  </div>
</template>

<script>
import { Carousel3d, Slide } from "vue-carousel-3d";
import { fetchRecommend } from "../../api";
import { mapGetters, mapState, mapActions } from "vuex";
import LoadingSpinner from "@/components/common/LoadingSpinner.vue";
import ArticleCard from "@/components/article/ArticleCard.vue";
import Footer from "../../components/navigation/Footer";

export default {
  name: "ArticleRecommend",
  data() {
    return {
      articles: [],
      keywords: [],
      likesCntList: [],
      pinCntList: [],
      commentCntList: [],
      isLoading: true,
      window: {
        width: 0,
      },
    };
  },
  computed: {
    ...mapState(["id_token"]),
    carouselHeight() {
      return this.window.width < 6 ? 1000 : 380;
      
    },
    ...mapGetters(['isLoggedIn']),
  },
  components: {
    "carousel-3d": Carousel3d,
    Slide,
    LoadingSpinner,
    ArticleCard,
    Footer,
  },
  methods: {
    ...mapActions(["getGoogleUserInfo"]),
    async fetchData() {
      const { data } = await fetchRecommend(this.id_token);
      this.isLoading = false;
      this.keywords = data.object.keyword;
      this.articles = data.object.articles;
      this.likesCntList = data.object.likesCntList;
      this.pinCntList = data.object.pinCntList;
      this.commentCntList = data.object.commentCntList;
    },
    handleResize() {
      this.window.width = window.innerWidth / 100;
      // this.window.height = window.innerHeight;
    },
  },
  mounted() {
    if (this.id_token) {
      this.getGoogleUserInfo(this.id_token);
    }
    this.fetchData();
  },
  created() {
    window.addEventListener("resize", this.handleResize);
    this.handleResize();
  },
  destroyed() {
    window.removeEventListener("resize", this.handleResize);
  },
};
</script>

<style scoped>
@keyframes typing {
  from {
    width: 0;
  }
}
@keyframes caret {
  50% {
    border-color: transparent;
  }
}
.carousel-3d-slide {
  border: none;
  background-color: transparent;
}
.home-nav {
  display: flex;
  height: 60px;
  align-items: center;
  padding: 0 1rem;
}
#intro {
  font-family: "Noto Serif KR", serif;
  font-weight: lighter;
  text-align: center;
  font-size: 13px;
  margin-bottom: 40px;
}
#outro {
  font-family: "Noto Serif KR", serif;
  text-align: center;
  margin: 2% 0 4% 0;
  font-size: 12px;
}
.outro-text {
  display: inline-block;
  margin: 0 auto;
  width: 59ch;
  font-family: "Montserrat", sans-serif, monospace;
  font-size: 1.2rem;
  font-weight: 500;
  overflow: hidden;
  white-space: nowrap;
  border-right: 0.05em solid;
  animation: typing 5.5s steps(60), caret 1s steps(1) infinite;
}
@media (max-width: 562px) {
  .outro-text {
    font-size: 0.625rem;
    font-weight: 900;
  }
}
</style>
