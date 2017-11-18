class IllustrationRegistry {
  constructor() {
    this.registry = {};
  }

  register(key, constructor) {
    this.registry[key] = constructor;
  }

  find(key) {
    return this.registry[key];
  }
}

const illustrationRegistry = new IllustrationRegistry();

export default illustrationRegistry;
