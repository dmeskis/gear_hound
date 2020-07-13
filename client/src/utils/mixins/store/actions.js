import axios from "axios"
const _ = require('lodash')

export default {
  setNamespace({ state}, namespace) {
    state._namespace = namespace
  },
  // index: ({ commit }, payload) => {
  //   commit("SET_LOADING", true)
  //   commit("CLEAR_ERRORS")

  //   const searchObject = SearchMixin.buildSearchObject(payload)
  //   axios
  //     .get(`search?q=${searchObject}`)
  //     .then((response) => {
  //       commit("SET_ALL", response)
  //     })
  //     .catch((e) => {
  //       commit("SET_ERRORS", e)
  //     })
  //     .finally(() => {
  //       commit("SET_LOADING", false)
  //     })
  // },
  // show: ({ commit }, payload) => {
  //   commit("SET_LOADING", true)
  //   commit("CLEAR_ERRORS")

  //   const modelNamespace = _.snakeCase(_.pluralize(payload.model))

  //   return axios
  //     .get(`${modelNamespace}/${payload.id}${payload.params || ""}`)
  //     .then((response) => {
  //       commit("SET_MODEL", response.data[payload.model])
  //       commit("SET_INCLUDE", response.data)
  //       return response.data[payload.model]
  //     })
  //     .catch((e) => {
  //       commit("SET_ERRORS", e)
  //     })
  //     .finally(() => {
  //       commit("SET_LOADING", false)
  //     })
  // },
  create: ({ commit, state }, payload) => {
    commit("SET_LOADING", true)
    commit("CLEAR_ERRORS")

    var modelNamespace = _.snakeCase(payload.model)
    console.log('poop!')
    console.log(state._namespace)
    axios
      .post('/api/users', payload.params)
      .then((response) => {
        console.log(response)
        console.log('YERT')
        commit("SET_MODEL", response.data[modelNamespace])
        commit("PUSH_ALL", response)
      })
      .catch((e) => {
        console.log('error')
        commit("SET_ERRORS", e)
      })
      .finally(() => {
        commit("SET_LOADING", false)
        commit("INCREMENT_RELOAD_KEY")
      })
  },
  // update: ({ commit }, payload) => {
  //   commit("SET_LOADING", true)
  //   commit("CLEAR_ERRORS")

  //   const modelNamespace = _.snakeCase(payload.model)

  //   return axios
  //     .put(
  //       _.pluralize(modelNamespace) + "/" + payload.id
  //     )
  //     .then((response) => {
  //       commit("SET_MODEL", response.data[modelNamespace])
  //     })
  //     .catch((e) => {
  //       commit("SET_ERRORS", e)
  //     })
  //     .finally(() => {
  //       commit("SET_LOADING", false)
  //       commit("INCREMENT_RELOAD_KEY")
  //     })
  // },
  // delete: ({ commit, dispatch }, payload) => {
  //   commit("SET_LOADING", true)
  //   commit("CLEAR_ERRORS")

  //   var modelNamespace = _.snakeCase(payload.model)

  //   axios
  //     .delete(_.pluralize(modelNamespace) + "/" + payload.id)
  //     .then(() => {
  //       commit("SET_MODEL", null)
  //     })
  //     .catch((e) => {
  //       commit("SET_ERRORS", e)
  //     })
  //     .finally(() => {
  //       commit("SET_LOADING", false)
  //       commit("INCREMENT_RELOAD_KEY")
  //     })
  // },
}