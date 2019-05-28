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
            Body: {{ answer.body }}
          </div>
          <div class="additional">
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
  </div>
</template>

<script>
import Comment from '@/components/Comment';

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
