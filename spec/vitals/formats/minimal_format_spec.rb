require 'spec_helper'

it_formats(
  Vitals::Formats::MinimalFormat,
  ['1.2', '1', '', '']*4
)


