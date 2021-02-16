export default {
  SET_ALL(state, payload) {
    state.all = parseResults(payload)
  },
  PUSH_ALL(state, payload) {
    const parsed = parseResults(payload)
    state.all = state.all.concat(parsed)
  },
  SET_MODEL(state, payload) {
    state.model = payload
  },
  SET_MODELS(state, payload) {
    state.models = payload
  },
  SET_META(state, payload) {
    state.meta = payload
  },
  SET_ERRORS(state, payload) {
    // const errors = _.get(payload, "response.data.errors", [])
    const errors = []
    state.errors = errors.map((e) => e.detail)
  },
  SET_LOADING(state, payload) {
    state.loading = payload
  },
  CLEAR_ERRORS(state) {
    state.errors = []
  },
  // TOGGLE_STATE(state, element) {
  //   state[element] = !state[element]
  // },
  RESET_STATE(state) {
    Object.assign(state, getDefaultState())
  },
}

// ----
// Private Functions
// ----

function parseResults(payload) {
  if (!payload) {
    return null
  }
  let output = []
  const models = Object.keys(payload.data)
  let count = models.length

  models.forEach((modelType) => {
    count--
    if (modelType !== "meta") {
      // Set model header and push records into section.
      if (modelType !== "results") {
        output.push({ header: modelType })
      }
      output = output.concat(payload.data[modelType])
      // Add divider for multi-model searches.
      if (count > 1) {
        output.push({ divider: true })
      }
    }
  })
  return output
}

export const getDefaultState = () => {
  return {
    all: [],
    model: null,
    meta: null,
    loading: false,
    errors: [],
    activeSearch: false,
  }
}