import Vue from 'vue';
import AppConfig from '@/AppConfig';

Vue.mixin({
  data() {
    return {
      bodyMaxLength: AppConfig.bodyMaxLength,
      titleMaxLength: AppConfig.titleMaxLength,
      authorMaxLength: AppConfig.authorMaxLength,
    };
  },
  methods: {
    sortBy(items, key) {
      return [...items].sort((a, b) => a[key].localeCompare(b[key]));
    },
    isLoggedIn() {
      if (!this.$store.state.email) {
        return false;
      }
      const expiresAt = this.$store.state.expiresAt; /* eslint-disable-line prefer-destructuring */
      const isExpired = Date.now() > Date.parse(expiresAt);
      return !isExpired;
    },
    myId() {
      return this.$store.state.id;
    },
  },
});
