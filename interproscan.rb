# Copyright [2016] EMBL-European Bioinformatics Institute
# Licensed under the Apache License, Version 2.0 (the License);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an AS IS BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Interproscan < Formula

  desc 'Scan sequences (protein and nucleic) against InterPro signatures'
  homepage 'http://www.ebi.ac.uk/interpro/interproscan.html'
  version '5.25-64.0'
  url 'ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.25-64.0/interproscan-5.25-64.0-64-bit.tar.gz'
  sha256 '7f123db975b18c0f21778fe3c110afd656fe0c3c0f999c848472f7a9d8df5d80'

  depends_on 'ensembl/moonshine/tmhmm'
  depends_on 'ensembl/moonshine/signalp'
  depends_on 'ensembl/moonshine/phobius'
  depends_on 'ensembl/ensembl/emboss'

  resource 'panther-models' do
    url 'ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-11.1.tar.gz'
    sha256 'a7bf916e758eac522fc1cd0e07f6460d65a42f7b4a694495a94ffa4bf84ec4ff'
  end

  def install
    tmhmm = Formula['ensembl/moonshine/tmhmm']
    signalp = Formula['ensembl/moonshine/signalp']
    phobius = Formula['ensembl/moonshine/phobius']
    emboss = Formula['ensembl/ensembl/emboss']

    inreplace 'interproscan.properties' do |s|
      # Handle tmhmm config
      s.gsub! 'bin/tmhmm/2.0c/decodeanhmm', "#{tmhmm.bin}/decodeanhmm.Linux_x86_64"
      s.gsub! 'data/tmhmm/2.0c/TMHMM2.0c.model', "#{tmhmm.lib}/TMHMM2.0.model"

      # Handle signalp dependencies
      s.gsub! 'bin/signalp/4.1/signalp', "#{signalp.bin}/signalp"
      s.gsub! 'bin/signalp/4.1/lib', "#{signalp.lib}"
      
      # Handle phobius dependencies
      s.gsub! 'bin/phobius/1.01/phobius.pl', "#{phobius.prefix}/phobius.pl"
      
      # Use emboss for getorf not bundled version
      s.gsub! 'bin/nucleotide/getorf', "#{emboss.bin}/getorf"
    end
    
    inreplace 'interproscan.sh', 'cd "$(dirname "$INSTALL_DIR")"', "cd #{prefix}"
    mv 'interproscan.sh', 'bin/.'

    prefix.install Dir['*']
    resource('panther-models').stage do
      (prefix+'data'+'panther').mkdir
      (prefix+'data'+'panther').install '11.1'
    end
  end
end
