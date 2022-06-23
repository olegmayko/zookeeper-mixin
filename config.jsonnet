{
  _config+:: {
    //duration: '1m',  // for statetement in the config for easier override
    labelSelector: 'app="zookeeper"',
    // namespaceSelector: 'namespace="default"', // provide namespace where zookeeper is deployed
  },
}
