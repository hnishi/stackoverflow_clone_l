<template>
  <div>
    <div class="body">
      {{ answer.body }}
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
};
</script>

<style scoped>
.body {
  word-break: break-all;
  white-space: pre-wrap;
}
</style>
