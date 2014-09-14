class WavesController < ApplicationController
  def index
    #waves = getWavesFromBackend(current_user.id)
    content_temp = 'Supercool map with wave path'
    mock_data = [{:id => 1,
                  :title => 'Confession',
                  :type => 'Text',
                  :rippled => '1483',
                  :distance => '3126',
                  :content => content_temp},
                 {:id => 2,
                  :title => 'Band Practice',
                  :type => 'Video',
                  :rippled => '13',
                  :distance => '9',
                  :content => content_temp},
                 {:id => 3,
                  :title => 'Cat',
                  :type => 'Image',
                  :rippled => '32749',
                  :distance => '7840',
                  :content => content_temp}]
    waves = mock_data

    render locals: {waves: waves}
  end
end