# Copyright (C) 2010-2012, InSTEDD
#
# This file is part of Verboice.
#
# Verboice is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Verboice is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Verboice.  If not, see <http://www.gnu.org/licenses/>.

class Channels::AfricasTalking < Channel
  config_accessor :username
  config_accessor :password
  config_accessor :api_key
  config_accessor :number
  config_accessor :limit

  attr_protected :guid

  before_create :create_guid

  def create_guid
    self.guid ||= Guid.new.to_s
  end

  def self.can_handle?(a_kind)
    a_kind == 'africas_talking'
  end

  def broker
    :twilio_broker
  end
end