import assert from 'power-assert';
import Vuex from 'vuex';
import { shallowMount } from '@vue/test-utils';
import '../TestHelper';
// import Question from '@/components/Question';
import Comment from '@/components/Comment';
import router from '@/router';

describe('Question', function () {
  let store;
  const comment = {
    user_id: '5aa2100737000037001811c3',
    id: '0GhVJIvT3TUqastruFr9',
    created_at: '2018-05-06T14:00:23+00:00',
    body: 'bodyXComment',
  };

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
      },
      actions: {
      },
    });
  });

  it('renders comment body', function () {
    const wrapper = shallowMount(Comment, {
      store,
      router,
      propsData: {
        comment,
      },
    });
    // console.log(wrapper.find('.comment').text())
    assert(wrapper.find('.comment').text().includes(comment.body));
  });
});
