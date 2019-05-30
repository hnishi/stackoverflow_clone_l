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

    <button
      class="pre_page_btn"
      @click="move_pre"
    />
    前の５件
    <button
      class="next_page_btn"
      @click="move_next"
    />
    次の５件

    <!-- {{ this.skip }} -->
  </div>
</template>

<script>

export default {
  name: 'QuestionListPage',
  data() {
    return {
      limit: 5,
      skip: 0,
    };
  },
  computed: {
    questions() {
      return this.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestions2();
  },
  methods: {
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
    retrieveQuestions2() {
      this.$store.dispatch('retrieveQuestions2', { limit: this.limit, skip: this.skip });
    },
    move_next() {
      this.skip = this.skip + 5;
      this.retrieveQuestions2();
    },
    move_pre() {
      this.skip = this.skip - 5;
      this.retrieveQuestions2();
    },
  },
};
</script>

<style scoped>
.title {
  display: inline-block;
  transition: .3s;
  -webkit-transform: scale(1);
  transform: scale(1);
}
.title:hover {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
/* .title:hover {
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
} */
/* .title {
  text-overflow: ellipsis;
  overflow: hidden;
} */
.pre_page_btn{
    border: 0px;
    width:50px;
    height:35px;
    background: url(../imgs/arrow_left.png) left top no-repeat;
}
.next_page_btn{
    margin-left: 15px;
    border: 0px;
    width:50px;
    height:35px;
    background: url(../imgs/arrow_right.png) left top no-repeat;
}
</style>
