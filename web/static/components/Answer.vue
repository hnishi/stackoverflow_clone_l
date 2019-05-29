<template>
  <div>
    <div class="main-area">
      <div class="content-area">
        <div v-if="editing">
          <form
            class="answer-form"
            @submit.prevent="update"
          >
            <div class="form-group">
              <label for="form-body">Body</label>
              <input
                id="form-body"
                v-model="editingAnswerBody"
                :maxlength="bodyMaxLength"
                class="body-edit form-control"
                type="text"
                minlength="1"
                required
              >
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
            </div>
          </form>
        </div>
        <div v-else>
          <div
            class="body"
          >
            {{ answer.body }}
            <!-- {{ answer.userId }}
            {{ `${(this.editing === false) && this.answer.id === this.$route.params.id}` }} -->
          </div>
          <div class="additional">
            Posted at {{ answer.createdAt }}
            by <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
              {{ answer.userId }}
            </router-link>

            <!-- <span v-if="!editing"> -->
            <span v-if="hasValidUser">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                回答の編集
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>
    <hr>

    <!-- <div v-if="hasValidUser">
      test!!!
      {{this.editing}}
      {{this.answer.userId}}
      {{this.$store.state.id}}
    </div> -->

    <div class="hidden_box">
      <label v-bind:for="answer_id">コメントを表示</label>
      <input
        v-bind:id="answer_id"
        type="checkbox"
      >
      <div class="hidden_show">
    <div
      v-for="comment in answer.comments"
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
          <!-- <label for="form-nody">コメントを投稿する</label> -->
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
      <hr>
    </div>

    <div v-else>
      コメントを投稿するにはログインしてください。
    </div>
  </div>
   </div>
    </div>
</template>

<script>
import Comment from '@/components/AnswerComment';

export default {
  name: 'Answer',
  components: {
    Comment,
  },
  props: {
    answer: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      answer_id: this.answer.id,
      newCommentbody: '',
      editing: false,
      editingAnswerBody: '',
      editingCommentBody: '',
    };
  },
  computed: {
    hasLogin() {
      // console.warn('DEBUG: ', !(this.$store.state.id === ''));
      return !(this.$store.state.id === '');
    },
    hasValidUser() {
      // console.warn('DEBUG: ', this.editing);
      return (this.editing === false) && this.answer.userId === this.$store.state.id;
    },
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingAnswerBody = this.answer.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      // console.warn(this.$route.params.id)
      // console.warn(this.answer.id)
      // console.warn(this.editingBody)
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id: this.answer.id, body: this.editingAnswerBody });
      this.editing = false;
    },
    commentSubmit() {
      this.editing = true;
      // this.editingBody = '';
    },
    submitComment() {
      this.$store.dispatch('createAnswerComment',
        { questionId: this.$route.params.id, answerId: this.answer.id, body: this.editingCommentBody });
      this.editingCommentBody = '';
      this.editing = false;
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
.question-form {
  margin-left: 30px;
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
</style>
