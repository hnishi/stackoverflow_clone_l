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
          <label for="form-nody">コメントを投稿する</label>
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
</style>
