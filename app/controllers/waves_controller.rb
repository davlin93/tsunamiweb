class WavesController < ApplicationController
  def index
    #waves = getWavesFromBackend(current_user.id)
    mock_data = [{:id => 1,
                  :content => 'Text',
                  :rippled => '1483',
                  :distance => '3126'},
                 {:id => 2,
                  :content => 'Video',
                  :rippled => '13',
                  :distance => '9'},
                 {:id => 3,
                  :content => 'Image',
                  :rippled => '32749',
                  :distance => '7840'}]
    waves = mock_data

    render locals: {waves: waves}
  end
end