<template>
  <div>
    <div v-if="hasValidQuestion">
      <question 
        :question="question" 
        class="question"
        @update="updateQuestion"
      />

      <div class="page-title">
        回答
      </div>

      <answer
        :answers="answers" 
        class="answer"
      />

      <!-- <div
      v-for="answer in answers"
      :key="answer.id"
      >
      <h5 class="answer">
          {{ answer.body }}
      </h5>
      <div class="additional">
        Posted at {{ answer.createdAt }}
        by <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
          {{ answer.userId }}
        </router-link>
      </div>
      <hr>
      </div> -->
      <router-link :to="{ name: 'QuestionListPage'}">
        一覧に戻る
      </router-link>
    </div>
  </div>
</template>

<script>
import Question from '@/components/Question';
import Answer from '@/components/Answer';
import Comment from '@/components/Comment';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
    Comment,
  },
  data() {
    return {
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
    answers(){
      return this.$store.state.answers
      // return this.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    return this.retrieveQuestion();
    return this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
  },
};
</script>

<style scoped>
.question {
  margin-bottom: 20px;
}
/* .answer {
  margin-bottom: 20px;
} */
.answer {
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
