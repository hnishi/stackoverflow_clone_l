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
                v-model="editingBody"
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
          </div>
          <div class="additional">
            Posted at {{ answer.createdAt }}
            by <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
              {{ answer.userId }}
            </router-link>

            <span v-if="!editing">
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
    <div>
      <form
        class="question-form"
        @submit.prevent="submitComment"
      >
        <div class="form-group">
          <label for="form-nody">コメントを投稿する</label>
          <textarea
            id="form-body"
            v-model="editingBody"
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
      editingBody: '',
    };
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.answer.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      // console.warn(this.$route.params.id)
      // console.warn(this.answer.id)
      // console.warn(this.editingBody)
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id: this.answer.id, body: this.editingBody });
      this.editing = false;
    },
    commentSubmit() {
      this.editing = true;
      // this.editingBody = '';
    },
    submitComment() {
      this.$store.dispatch('createAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, body: this.editingBody });
      this.editingBody = '';
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
  white-space: pre-wrap;
}
.comment-list {
  margin-left: 10px;
}
</style>
