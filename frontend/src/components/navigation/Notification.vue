<template>
  <div class="notices">
    <div class="notice" :class="{read : noti.ready === 1}" v-if="noti.type === 'like'">
      <i style="color: crimson" class="far fa-heart"></i>
      <div class="noti-text" :id="noti.notificationid" @click="goToPage">
        <p>{{ noti.othernickname }} 님이 {{ noti.content.slice(0,9) }}... 글을 좋아합니다.</p>
      </div>
      <i style="cursor: pointer" class="fas fa-times" :id="noti.notificationid" @click="deleteNotification"></i>
    </div>
    <div class="notice" :class="{read : noti.ready === 1}" v-else-if="noti.type === 'comment'">
      <i style="color: crimson" class="far fa-heart"></i>
      <div class="noti-text" :id="noti.notificationid" @click="goToPage">
        <p>{{ noti.othernickname }} 님이 {{ noti.content.slice(0,9) }}... 글에 댓글을 남겼습니다.</p>
      </div>
      <i style="cursor: pointer" class="fas fa-times" :id="noti.notificationid" @click="deleteNotification"></i>
    </div>
    <div class="notice" :class="{read : noti.ready === 1}" v-else-if="noti.type === 'pin'">
      <i style="color: crimson" class="far fa-bookmark"></i>
      <div class="noti-text" :id="noti.notificationid" @click="goToPage">
        <p>{{ noti.othernickname }} 님이 {{ noti.content.slice(0,9) }}... 글을 찜했습니다.</p>
      </div>
      <i style="cursor: pointer" class="fas fa-times" :id="noti.notificationid" @click="deleteNotification"></i>
    </div>
    <div class="notice" :class="{read : noti.ready === 1}" v-else>
      <i style="color: crimson" class="far fa-user"></i>
      <div class="noti-text" :id="noti.notificationid" @click="goToPage">
        <p>{{ noti.othernickname }} 님이 당신을 팔로우합니다.</p>
      </div>
      <i style="cursor: pointer" class="fas fa-times" :id="noti.notificationid" @click="deleteNotification"></i>
    </div>
  </div>
</template>

<script>
  import { submitNotiRead, submitNotiDelete } from "../../api";
  import { mapGetters } from 'vuex'
  export default {
    name: "Notification",
    props: {
      noti: Object
    },
    computed: {
      ...mapGetters(["isLoggedIn"])
    },
    methods: {
      goToPage(event) {
        if (this.isLoggedIn) {
          const notificationId = event.target.parentNode.id
          submitNotiRead(notificationId)
            .then(() => {
              this.noti.ready = 1
              if (this.noti.type === "follow") {
                this.$router.push({name: "Dummy", params: {nickname: this.noti.othernickname}})
              } else if (this.noti.type === "comment") {
                this.$router.push({name: "Dummy", params: {id: this.noti.articleid, at: '#comment'}})
              } else this.$router.push({name: "Dummy", params: {id: this.noti.articleid}})
              // if(res.data.status) this.$store.state.notificationCnt--;
            }
          )
          .catch(err => {
            console.log(err)
            }
          )
        }
      },
      deleteNotification(event) {
        if (this.$store.getters.isLoggedIn) {
          const notificationId = event.target.id
          submitNotiDelete(notificationId)
            .then(() => {
              this.$store.state.notification = this.$store.state.notification.filter(
                noti => Number(noti.notificationid) !== Number(notificationId))
              const navBar = document.querySelector(".notification");
              navBar.classList.remove("disabled")
            })
            .catch(err => console.log(err))
        }
      }
    }
  }
</script>

<style scoped>
  .notices {
    text-align: justify;
    width: 300px;
    border-radius: 5px;
    border: gainsboro 1px solid;
    background-color: ghostwhite;
    margin: 10px;
  }
  .notice {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
    box-shadow: 5px 5px 5px gray;
  }
  i {
    font-size: 20px;
  }
  .noti-text {
    cursor: pointer;
    padding: 0 10px 0 10px
  }
  .read {
    background-color: gainsboro;
    color: #9fa3af;
  }
</style>