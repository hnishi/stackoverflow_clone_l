<template>
  <div>
    <div v-if="editing">
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="editingTitle"
          :maxlength="titleMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required
        >
      </div>
    </div>
    <div v-else>
      <div class="page-title">
        <h1>{{ question.title }}</h1>
      </div>
    </div>
    <hr>

    <div class="main-area">
      <div class="content-area">
        <div v-if="editing">
          <form
            class="question-form"
            @submit.prevent="update"
          >
            <div class="form-group">
              <label for="form-body">本文</label>
              <textarea
                id="form-body"
                v-model="editingQuestionBody"
                :maxlength="bodyMaxLength"
                class="body-edit form-control"
                type="text"
                minlength="1"
                required
              />
            </div>
            <div class="form-group">
              <button
                class="btn btn-primary mb-2"
                type="submit"
              >
                保存
              </button>
              <button
                class="cancel-edit-button btn btn-outline-primary mb-2"
                type="submit"
                @click.prevent="cancelEdit"
              >
                キャンセル
              </button>

              <button
                class="btn btn-primary mb-2"
                type="submit"
                @click="deleteQuestion"
              >
                質問の削除
              </button>
            </div>
          </form>
        </div>
        <div v-else>
          <div
            class="body"
          >
            {{ question.body }}
          </div>
          <div class="additional">
            Posted at {{ question.createdAt }}
            by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
              {{ question.userId }}
            </router-link>

            <!-- <span v-if="!editing"> -->
            <span v-if="hasValidUser">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                質問の編集
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>

    <button
      id="jaJP"
      type="button"
      value="Say"
      class="speech_btn"
      @click="say_text"
    />

    <hr>
    <div>
      <!-- <p>{{ `print1: ${question.title}` }}</p> -->
      <button
        class="good_btn"
        type="vote"
        @click="vote_like"
      />
      {{ question.likeVoterIds.length }}
      <button
        class="bad_btn"
        type="vote"
        @click="vote_dislike"
      />
      {{ question.dislikeVoterIds.length }}
    </div>
    <div class="hidden_box">
      <label for="label1">コメントを表示</label>
      <input
        id="label1"
        type="checkbox"
      >
      <div class="hidden_show">
        <div
          v-for="comment in question.comments"
          :key="comment.id"
        >
          <comment
            :comment="comment"
            class="comment"
          />
          <hr>
        </div>


        <div v-if="hasLogin">
          <form
            class="question-form"
            @submit.prevent="submitComment"
          >
            <div class="form-group">
              <h5>コメントを投稿する</h5>
              <textarea
                id="form-body"
                v-model="editingCommentBody"
                class="body-edit form-control"
                minlength="1"
                maxlength="50"
                required
              />
            </div>
            <div class="form-group">
              <button
                class="btn btn-primary mb-2"
                type="submit"
                @click="commentSubmit"
              >
                投稿
              </button>
            </div>
          </form>
        </div>

        <div v-else>
          コメントを投稿するにはログインしてください。
        </div>
      </div>
    </div>
    <hr>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newCommentbody: '',
      editing: false,
      editingQuestionBody: '',
      editingCommentBody: '',
      editingTitle: '',
    };
  },
  computed: {
    hasLogin() {
      // console.warn('DEBUG: ', !(this.$store.state.id === ''));
      return !(this.$store.state.id === '');
    },
    hasValidUser() {
      // console.warn('DEBUG: ', this.editing);
      return (this.editing === false) && this.question.userId === this.$store.state.id;
    },
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingQuestionBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    commentSubmit() {
      this.editing = true;
      // this.editingBody = '';
    },
    cancelEdit() {
      this.editing = false;
    },
    submitComment() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.editingCommentBody });
      this.editingCommentBody = '';
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, body: this.editingQuestionBody });
      this.editing = false;
    },
    vote_like() {
      this.$store.dispatch('addVote', { questionId: this.$route.params.id, voteType: 'like_vote' });
    },
    vote_dislike() {
      this.$store.dispatch('addVote', { questionId: this.$route.params.id, voteType: 'dislike_vote' });
    },
    say_text() {
      // console.log(this.question.body)
      if (typeof SpeechSynthesisUtterance === 'undefined') { return; }
      const u = new SpeechSynthesisUtterance();
      u.text = this.question.body;
      u.lang = 'ja-JP';
      u.rate = 1.0;
      window.speechSynthesis.speak(u);
    },
    deleteQuestion() {
      // console.log(this.question.body)
      this.$store.dispatch('deleteQuestion', { questionId: this.$route.params.id });
      this.$router.push({ path: '/' });
    },
  },
};
</script>

<style scoped>
.page-title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.body {
  word-break: break-all;
  white-space: pre-line;
}
.comment-list {
  margin-left: 10px;
}
/*全体*/
.hidden_box {
    margin: 2em 0;/*前後の余白*/
    padding: 0;
    position: relative;
  display: inline-block;
  /* padding: 0.25em 0.5em; */
  text-decoration: none;
  /* color: #FFF; */
  /* background: #fd9535;背景色 */
  /* border-bottom: solid 2px #d27d00;少し濃い目の色に */
  border-radius: 4px;/*角の丸み*/
  /* box-shadow: inset 0 2px 0 rgba(255,255,255,0.2), 0 2px 2px rgba(0, 0, 0, 0.19); */
  font-weight: bold;
  font-size: small;
}

/*ボタン装飾*/
.hidden_box label {
    padding: 5px;
    border-radius: 4px;/*角の丸み*/
    color: #FFF;
    background: #fd9535;
    border-bottom: solid 2px #d27d00;
    box-shadow: inset 0 2px 0 rgba(255,255,255,0.2), 0 2px 2px rgba(0, 0, 0, 0.19);
    font-weight: bold;
    /* border: solid 2px black; */
    cursor :pointer;
    text-align: center;
    margin-left: 50px;
}

/*ボタンホバー時*/
.hidden_box label:hover {
    background: #efefef;
}

/*チェックは見えなくする*/
.hidden_box input {
    display: none;
}

/*中身を非表示にしておく*/
.hidden_box .hidden_show {
    height: 0;
    padding: 0;
    overflow: hidden;
    opacity: 0;
    transition: 0.8s;
}

/*クリックで中身表示*/
.hidden_box input:checked ~ .hidden_show {
    padding: 10px 0;
    height: auto;
    opacity: 1;
}
.good_btn{
    border: 0px;
    width:50px;
    height:30px;
    background: url(../imgs/good.png) left top no-repeat;
}
.bad_btn{
    margin-left: 15px;
    border: 0px;
    width:50px;
    height:30px;
    background: url(../imgs/bad.png) left top no-repeat;
}
.speech_btn{
    border: 0px;
    width:50px;
    height:40px;
    background: url(../imgs/speech.png) left top no-repeat;
}
</style>
