

export default {
  all: (state) => {
    return state.all
  },
  model: (state) => {
    return state.model
  },
  models: (state) => {
    return state.models
  },
  meta: (state) => {
    return state.meta
  },
  loading: (state) => {
    return state.loading
  },
  errors: (state) => {
    return state.errors
  },
  // findById: (state) => (options) => {
  //   return state.all.find((record) => record.id === options.id)
  // },
  // findBy: (state) => (options) => {
  //   const filteredState = state.all.filter((record) => {
  //     if (record[options.attribute] === options.value) {
  //       return record
  //     }
  //   })
  //   return filteredState[0]
  // },
  // where: (state) => (options) => {
  //   const filteredState = state.all.filter((record) => {
  //     if (record[options.attribute] === options.value) {
  //       return record
  //     }
  //   })
  //   return filteredState
  // },
  // activeSearch: (state) => {
  //   return state.activeSearch
  // },
  // reloadKey: (state) => {
  //   return state.reloadKey
  // },
}
