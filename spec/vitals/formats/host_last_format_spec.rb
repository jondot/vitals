require 'spec_helper'

it_formats(
  Vitals::Formats::HostLastFormat,
  %w{
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.1.2.host_foo_bar_baz_qux
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.1.host_foo_bar_baz_qux
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.host_foo_bar_baz_qux
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.host_foo_bar_baz_qux

    env.service.1.2.host
    env.service.1.host
    env.service.host
    env.service.host

    env.1.2.host
    env.1.host
    env.host
    env.host

    env.service.1.2
    env.service.1
    env.service
    env.service

    service.1.2.host
    service.1.host
    service.host
    service.host

    env.1.2
    env.1
    env
    env

    1.2.host
    1.host
    host
    host

    service.1.2
    service.1
    service
    service
  }
)
