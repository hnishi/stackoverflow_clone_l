<template>
  <div>
    <div class="page-title">
      {{ question.title }}
    </div>
    <div class="body">
      {{ question.body }}
    </div>
    <div
      v-for="comment in question.comments"
      :key="comment.id"
       >
      <comment :comment="comment" />
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
};
</script>

<style scoped>
.comment{
  margin-left: 10px;
}
</style>
