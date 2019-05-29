<template>
  <div>
    <div class="page-title">
      質問を見る
    </div>
    <div class="title">
      <router-link to="question/create">
        質問する
      </router-link>
    </div>
    <hr>
    <div
      v-for="question in questions"
      :key="question.id"
    >
      <h5 class="title">
        <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
          {{ question.title }}
        </router-link>
      </h5>
      <div class="additional">
        Posted at {{ question.createdAt }}
        by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
          {{ question.userId }}
        </router-link>
      </div>
      <hr>
    </div>
  </div>
</template>

<script>

export default {
  name: 'QuestionListPage',
  computed: {
    questions() {
      return this.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestions();
  },
  methods: {
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
  },
};
</script>

<style scoped>
.title:hover {
    display: inline-block;
    animation: hurueru .1s  infinite;
}
.additional:hover {
    display: inline-block;
    animation: hurueru .1s  infinite;
}

@keyframes hurueru {
    0% {transform: translate(0px, 0px) rotateZ(0deg)}
    25% {transform: translate(2px, 2px) rotateZ(1deg)}
    50% {transform: translate(0px, 2px) rotateZ(0deg)}
    75% {transform: translate(2px, 0px) rotateZ(-1deg)}
    100% {transform: translate(0px, 0px) rotateZ(0deg)}
}
/* .title {
  text-overflow: ellipsis;
  overflow: hidden;
} */

</style>
