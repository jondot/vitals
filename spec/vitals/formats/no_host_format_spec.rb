require 'spec_helper'

it_formats(
  Vitals::Formats::NoHostFormat,
  %W{
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.1.2
    env_foo_bar_baz_qux.service_foo_bar_baz_qux.1
    env_foo_bar_baz_qux.service_foo_bar_baz_qux
    env_foo_bar_baz_qux.service_foo_bar_baz_qux

    env.service.1.2
    env.service.1
    env.service
    env.service

    env.1.2
    env.1
    env
    env

    env.service.1.2
    env.service.1
    env.service
    env.service

    service.1.2
    service.1
    service
    service

    env.1.2
    env.1
    env
    env

    1.2
    1
    #{''}
    #{''}

    service.1.2
    service.1
    service
    service
  }
)
