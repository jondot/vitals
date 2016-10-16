require 'spec_helper'

it_formats(
  Vitals::Formats::ProductionFormat,
  %w{
    env_foo_bar_baz_qux.host_foo_bar_baz_qux.service_foo_bar_baz_qux.1.2
    env_foo_bar_baz_qux.host_foo_bar_baz_qux.service_foo_bar_baz_qux.1
    env_foo_bar_baz_qux.host_foo_bar_baz_qux.service_foo_bar_baz_qux
    env_foo_bar_baz_qux.host_foo_bar_baz_qux.service_foo_bar_baz_qux

    env.host.service.1.2
    env.host.service.1
    env.host.service
    env.host.service

    env.host.1.2
    env.host.1
    env.host
    env.host

    env.service.1.2
    env.service.1
    env.service
    env.service

    host.service.1.2
    host.service.1
    host.service
    host.service

    env.1.2
    env.1
    env
    env

    host.1.2
    host.1
    host
    host

    service.1.2
    service.1
    service
    service
  }
)
