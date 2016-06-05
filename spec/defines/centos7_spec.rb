require 'spec_helper'

describe 'community_kickstarts::centos7' do
  let(:title) { '/tmp/kickstart.cfg' }
  let(:partition_configuration) do
    {
      'zerombr' => 'yes',
      'clearpart' => '--all --initlabel',
      'part' => [
        '/boot --fstype ext3 --size 250',
        'pv.2 --size 5000 --grow',
      ],
      'volgroup' => 'VolGroup00 --pesize 32768 pv.2',
      'logvol' => [
        '/ --fstype ext4 --name LogVol00 --vgname VolGroup00 --size 1024 --grow',
        'swap --fstype swap --name LogVol01 --vgname VolGroup00 --size 256 --grow --maxsize 512'
      ]
    }
  end
  let(:packages) { ['@base'] }
  let(:repos) do
    {
      'base' => {
        'baseurl' => 'http://mirror.centos.org/centos/7/os/x86_64'
      }
    }
  end

  context 'when using defaults' do
    it { is_expected.to compile }

    it 'contains all of the repos' do
      repos.keys.each do |repo|
        is_expected.to contain_file(title).with_content %r{^repo --name #{repo}}
      end
    end

    it 'contains a valid packages section' do
      is_expected.to contain_file(title).with_content %r{^%packages$}
    end
  end

  context 'with only the partition_configuration parameter defined' do
    let(:params) { { partition_configuration: partition_configuration } }

    it { is_expected.to compile }
    it 'contains all of the partition commands' do
      partition_configuration.keys.each do |command|
        is_expected.to contain_file(title).with_content %r{^#{command}}
      end
    end
  end
end
