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

require 'spec_helper'

module Parsers
  module UserFlowNode
    describe MarkAsSuccessful do

      let(:call_flow) { CallFlow.make }

      it "should compile to a verboice equivalent flow" do
        mark_as_successful = MarkAsSuccessful.new call_flow, 'id' => 1,
          'type' => 'mark_as_successful',
          'name' => 'MarkAsSuccessful'

        mark_as_successful.equivalent_flow.first.should eq(
          Compiler.parse do |c|
            c.Label 1
            c.StartUserStep :mark_as_successful, 1, "MarkAsSuccessful"
            c.Trace call_flow_id: call_flow.id, step_id: 1, step_name: 'MarkAsSuccessful', store: '"Marked as successful."'
            c.AssignValue "status", "successful"
          end.first
        )
      end
    end
  end
end
