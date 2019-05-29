<template>
  <div>
    <div class="main-area">
      <div class="content-area">
        <div v-if="editing">
          <form
            class="comment-form"
            @submit.prevent="updateQuestionComment"
          >
            <div class="form-group">
              <label for="form-body"></label>
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
          <div class="comment">
            {{ comment.body }}
            <span class="additional">
              -- Posted at {{ comment.createdAt }} by
              <router-link :to="{ name: 'UserDetailPage', params: { id: comment.userId }}">
                {{ comment.userId }}
              </router-link>
              <span v-if="hasValidUser">
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
  computed: {
    hasLogin() {
      // console.warn('DEBUG: ', !(this.$store.state.id === ''));
      return !(this.$store.state.id === '');
    },
    hasValidUser() {
      // console.warn('DEBUG: ', this.editing);
      return (this.editing === false) && this.comment.userId === this.$store.state.id;
    },
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.comment.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    updateQuestionComment() {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id: this.comment.id, body: this.editingBody });
      this.editing = false;
    },
  },
};
</script>

<style scoped>
.comment{
  margin-left: 10px;
  animation-name:fade-in3;
  animation-duration:2s;
  animation-timing-function: ease-out;
  /* animation-delay:1s; */
  animation-iteration-count:1;
  animation-direction:normal;
  animation-fill-mode: forwards;
}
@keyframes fade-in3 {
  0% {opacity: 0; transform: translate3d(0,20px,0);}
  100% {opacity: 1; transform: translate3d(0,0,0);}
}
</style>
