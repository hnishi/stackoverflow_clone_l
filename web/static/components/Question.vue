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
        {{ question.title }}
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
              <label for="form-body">Body</label>
              <input
                id="form-body"
                v-model="editingBody"
                :maxlength="authorMaxLength"
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
            Body: {{ question.body }}
          </div>
          <div class="additional">
            <span v-if="!editing">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                更新
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>

    <div
      v-for="comment in question.comments"
      :key="comment.id"
    >
      <comment :comment="comment" 
      class = "comment"
      @update="updateQuestionComment" 
      />

      <hr>
    </div>

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
      editingBody: '',
      editingTitle: '',
    };
  },
  mounted() {
    this.updateQuestionComment();
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, body: this.editingBody });
      this.editing = false;
    },
    updateQuestionComment(commentId, body) {
      this.$store.dispatch('updateQuestionComment', { id: this.question.id, commentId, body });
    }
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
