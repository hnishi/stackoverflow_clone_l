<template>
  <div>
    <!-- <p>{{ `print1: ${question.title}` }}</p> -->

    <div v-if="hasValidQuestion">
      <question
        :question="question"
        class="question"
        @update="updateQuestion"
      />
    </div>

    <div class="page-title">
      {{ `${(answers).length}` }} 件の回答
    </div>

    <!-- <p>{{ `print1: ${(answers).length}` }}</p> -->
    <div
      v-for="answer in answers"
      :key="answer.id"
    >
      <!-- {{ `print2: ${answer.id}` }} -->
      <answer
        :answer="answer"
        class="answer"
      />
    </div>

    <div class="page-title">
      回答する
    </div>

    <div v-if="hasLogin">
      <form
        class="answer-form"
        @submit.prevent="submit"
      >
        <div class="form-group">
          <label for="form-nody">回答を投稿する</label>
          <textarea
            id="form-body"
            v-model="body"
            class="body-edit form-control"
            minlength="1"
            maxlength="3000"
            required
          />
        </div>
        <div class="form-group">
          <button
            class="btn btn-primary mb-2"
            type="submit"
          >
            投稿
          </button>
        </div>
      </form>
    </div>

    <div v-else>
      回答を投稿するにはログインしてください。
    </div>

    <hr>

    <router-link :to="{ name: 'QuestionListPage'}">
      質問の一覧に戻る
    </router-link>

    <div>
      <!-- <p>{{ `print1: ${question.title}` }}</p> -->
      <button
        type="vote"
        @click="vote_like"
      >
        好き
      </button>
            
      <button
        type="vote"
        @click="vote_dislike"
      >
        嫌い
      </button>
      <!-- <p>{{ `like: ${Object.keys(question.likeVoterIds).length}` }}</p> -->
      好き数: {{ num_like }} , 嫌い数: {{ num_dislike }}
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
      body: '',
      num_like: 0,
      num_dislike: 0,
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },
    hasLogin() {
      // console.warn('DEBUG: ', !(this.$store.state.id === ''));
      return !(this.$store.state.id === '');
    },
    question() {
      return this.$store.state.question;
    },
    answers() {
      // return this.$store.state.answers
      return this.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestion();
    this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id })
      .then(() =>{
        this.num_like = (this.$store.state.question.likeVoterIds).length;
        this.num_dislike = (this.$store.state.question.dislikeVoterIds).length;
      });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
    retrieveAnswers() {
      // console.warn('hoghoge')
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    // 回答の作成
    submit() {
      this.$store.dispatch('createAnswer', { questionId: this.$route.params.id, body: this.body })
        .then(() => {
          this.$router.push({ path: `/question/${this.$route.params.id}` });
          this.body = '';
        });
    },
    vote_like() {
      // console.dir(this.$store.state.question);
      // console.log((this.$store.state.question.likeVoterIds).length);
      // this.num_like = (this.$store.state.question.likeVoterIds).length;
      this.$store.dispatch('addVote', { questionId: this.$route.params.id, voteType: "like_vote" })
        .then(() => {
          this.num_like = (this.$store.state.question.likeVoterIds).length;
        })
        .then(() => {
          this.retrieveQuestion();
        });
      return (this.$store.state.question.likeVoterIds).length;
    },
    vote_dislike() {
        this.$store.dispatch('addVote', { questionId: this.$route.params.id, voteType: "dislike_vote" })
        .then(() => {
          this.num_dislike = (this.$store.state.question.dislikeVoterIds).length;
        })
        .then(() => {
          this.retrieveQuestion();
        });
      return (this.$store.state.question.dislikeVoterIds).length;
    },
  },
};
</script>

<style scoped>
.question {
  margin-bottom: 20px;
}
.answer {
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
