<template>
  <div>
    <div class="home">
      <div class="main-wrapper">
        <div class="primary">
          <br />
          <router-view :key="$route.fullPath"/>
        </div>
        <div class="secondary secondary-b">
          <HashTag />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapActions } from "vuex";
import HashTag from "../../components/homeNav/HashTag";
export default {
  components: {
    HashTag
  },
  computed: {
    ...mapState(["id_token"]),
  },
  methods: {
    ...mapActions(["getGoogleUserInfo"]),
  },
  mounted() {
    if (this.id_token) {
      this.getGoogleUserInfo(this.id_token);
    }
  },
};
</script>

<style scoped>
.home-nav {
  display: flex;
  height: 60px;
  align-items: center;
  padding: 0 1rem;
}

.home {
  padding-top: 60px;
}
.primary {
  padding: 1rem;
  padding-top: 70px;
  width: 100%;
  height: 100vh;
}
.secondary-b {
  width: 300px;
}
.secondary {
  padding: 1rem;
  padding-top: 70px;
}
.main-wrapper {
  display: flex;
  flex-wrap: wrap;
  margin: auto;
}
@media (max-width: 414px) {
  .home-nav {
    font-size: 0.75rem;
  }
}
@media (min-width: 1024px) {
  .home {
    display: flex;
    /* flex-wrap: wrap; */
  }
  .header {
    width: 100%;
  }
  .nav {
    width: 100%;
  }
  .secondary {
    width: 20%;
  }
  .primary {
    width: 80%;
    padding-top: 70px;
  }
}
@media (min-width: 1440px) {
  .secondary {
    min-width: 15%;
  }
  .primary {
    /* width: calc(100% - 600px); */
    /* flex-grow:1 */
    flex: 1 1 auto;
    /* fixed된 형태로 배치되고 싶다면 width를 사용하기를 추천한다. 줄바꿈이 상관 없다면 -예를 들면, 해쉬태그- flex로 유연하게 하는 것이 좋음 */
  }
}
.user-item {
  margin: 1rem 0;
  display: flex;
}

.user-photo {
  width: 50px;
  height: 50px;
  flex-shrink: 0;
  border: 2px solid #333;
  border-radius: 50%;
  background-color: rgb(144, 153, 240);
  background-repeat: no-repeat;
  background-position: center;
  background-size: 100%;
  margin-right: 0.5em;
}
.friend-item {
  align-items: center;
}
.user-name {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
