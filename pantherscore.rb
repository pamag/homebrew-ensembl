class Pantherscore < Formula
  desc 'Score protein sequences against the PANTHER HMM library'
  homepage 'ftp://ftp.pantherdb.org/hmm_scoring/10.0/1.03/'
  url 'ftp://ftp.pantherdb.org/hmm_scoring/10.0/1.03/pantherScore1.03.zip'
  sha256 'dad3aea7290e52372fd048a9de9242f80a52888a238eefb48919592b89e280be'
  version '1.03'

  def install
    cd 'pantherScore1.03' do
      system 'wget', 'https://raw.githubusercontent.com/Ensembl/pantherScore/master/pantherScore1.03.patch'
      system 'patch', '-p1', '-i', 'pantherScore1.03.patch'
      inreplace 'pantherScore.pl', '#!/usr/bin/env perl', "#!/usr/bin/env perl\nuse lib '#{libexec}';"
      bin.install 'pantherScore.pl'
      libexec.install Dir['lib/*']
    end
  end
end