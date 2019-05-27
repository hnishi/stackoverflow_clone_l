<template>
  <div>
    <!-- !not_implemented! -->
    <div class="main-area">
      <div class="content-area">
        <div v-if="editing">
          <form
            class="question-form"
            @submit.prevent="updateComment"
          >
            <div class="form-group">
              <label for="form-body"></label>
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
          <div class="comment">
            {{ comment.body }}
            <span class="additional">
              --
              Posted at {{comment.createdAt}} by
              <router-link :to="{ name: 'UserDetailPage', params: { id: comment.userId }}">
               {{ comment.userId }}
              </router-link>
              <span v-if="!editing">
                <button
                  type="button"
                  class="edit-button btn btn-link"
                  @click="startEdit"
                >
                  更新
                </button>
              </span>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Comment',
  components: {
  },
  props: {
    comment: {
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
      this.editingBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    cancelEdit() {
      this.editing = false;
    },
    updateQuestionComment(commentId, body) {
      this.$store.dispatch('updateQuestionComment', { id: this.question.id, commentId, body });
    }
  },
};
</script>

<style scoped>
.comment{
  margin-left: 10px;
}
</style>
