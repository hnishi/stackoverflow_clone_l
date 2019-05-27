<template>
  <div>
    <!-- !not_implemented! -->
    <div class="comment">
      {{ comment.body }}
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
};
</script>

<style scoped>
.comment{
  margin-left: 10px;
}
</style>
