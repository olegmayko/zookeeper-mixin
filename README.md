# Prometheus Mixin

A Prometheus mixin bundles all of the metric related concerns into a single
package for users of the application to consume.
Typically this includes dashboards, recording rules, alerts and alert logic
tests.

By creating a mixin, application maintainers and contributors to the project
can enshrine knowledge about operating the application and potential SLO's
that users may wish to use.

For more details about this concept see the [monitoring-mixins](https://github.com/monitoring-mixins/docs)
project on GitHub.


## Using the mixin with kube-prometheus

See the [kube-prometheus](https://github.com/coreos/kube-prometheus#kube-prometheus)
project documentation for instructions on importing mixins.

## Using the mixin as raw YAML files

If you don't use the jsonnet based `kube-prometheus` project then you will need to
generate the raw yaml files for inclusion in your Prometheus installation.

Install the `jsonnet` dependencies:
```
$ go get github.com/google/go-jsonnet/cmd/jsonnet
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

Generate yaml:
```
$ make
```
