import Vue from 'vue'
import Vuex from 'vuex'
import dispatchActionForAllModules from '@utils/dispatch-action-for-all-modules'

import modules from './modules'

Vue.use(Vuex)

const store = new Vuex.Store({
  modules,
  // Enable strict mode in development to get a warning
  // when mutating state outside of a mutation.
  // https://vuex.vuejs.org/guide/strict.html
  strict: process.env.NODE_ENV !== 'production',
  actions: {
    bindNamespaces({commit}, {_modulesNamespaceMap}) {
        Object.entries(_modulesNamespaceMap).forEach(([namespace, module]) => {
          console.log(module, namespace)
            commit('bindNamespace', {module, namespace});
        });
    },
  },
  mutations: {
    bindNamespace(_, {module, namespace}) {
        Vue.set(module.state, '_namespace', namespace);
    },
  },
})

export default store

// Automatically run the `init` action for every module,
// if one exists.
dispatchActionForAllModules('init')
