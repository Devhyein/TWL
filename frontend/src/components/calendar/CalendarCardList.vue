<template>
  <div class="calendar-list-container">
    <ProfileInfo :userInfo="userInfo"></ProfileInfo>
    <div v-if="isLoading">
      <LoadingSpinner />
    </div>
    <div v-else>
      <div class="news-index">
        <p>⚡ News ⚡</p>
      </div>
      <br />

      <div v-if="this.isNotNull">
        <ArticleCard
          v-for="(article, index) in articles"
          :key="article._id"
          :article="article"
          :keywords="keywords[index]"
          :commentCnt="commentCntList[index]"
          :likesCnt="likesCntList[index]"
          :pinCnt="pinCntList[index]"
        />
      </div>
      <div v-else style="text-align : center; font-weight : bold">
        <br />
        <br />검색 결과가 없습니다!
        <br />
        <br />
        <br />
        <br />
      </div>

      <div id="bottomSensor"></div>
    </div>
  </div>
</template>

<script>
import ProfileInfo from "@/components/profile/ProfileInfo.vue";
import ArticleCard from "@/components/article/ArticleCard.vue";
import LoadingSpinner from "@/components/common/LoadingSpinner.vue";
import { mapState, mapActions } from "vuex";
// import scrollMonitor from "scrollmonitor";
  export default {
    components: {
    ProfileInfo,
    ArticleCard,
    LoadingSpinner,
  },

  data() {
    return {
      articles: [],
      keywords: [],
      likesCntList: [],
      pinCntList: [],
      commentCntList: [],
      isLoading: true,
      page: 0,
      userInfo: {},
      isNotNull: true,
    };
  },
  computed: {
    ...mapState(["id_token"]),
  },
  methods: {

    ...mapActions(["getGoogleUserInfo"]),
    async fetchData() {
      const res = this.data.data;

      this.isLoading = false;
      this.keywords = [...this.keywords, ...res.data.object.keyword];
      this.articles = [...this.articles, ...res.data.object.article];
      this.likesCntList = [
        ...this.likesCntList,
        ...res.data.object.likesCntList,
      ];
      this.commentCntList = [
        ...this.commentCntList,
        ...res.data.object.commentCntList,
      ];
      this.pinCntList = [...this.pinCntList, ...res.data.object.pinCntList];

      this.userInfo = this.data.userInfo;

      if (!res.data.status) this.isNotNull = false;
    },
  },
  mounted() {
  },
  created() {
    this.fetchData();
  },
  props: {
    data: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style>
.calendar-list-container {
  padding-top: 60px;
}
.news-index {
  max-width: 850px;
  width: 96%;
  display: flex;
  justify-content: left;
  margin: auto;
}
#bottomSensor {
  height: 10px;
}

::-webkit-scrollbar {
  -webkit-appearance: none;
}
::-webkit-scrollbar {
  width: 10px;
}

::-webkit-scrollbar-track {
  background: #eee;
  border: 1px solid #eee;
}

::-webkit-scrollbar-thumb {
  background: rgb(144, 153, 240);
  border: 1px solid #eee;
  height: 100px;
  border-radius: 5px;
}
</style>
