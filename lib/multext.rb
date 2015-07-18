class Multext
  attr_accessor :language, :data, :msd

  def self.install
  end

  def initialize(language=:en)
    @data     = []
    @language = language
    @msd      = Multext::MSD.new
    

    basedir  = "#{ENV['HOME']}/multext"
    filename = "wfl-#{language}.txt"

    File.foreach(File.join(basedir, filename)) do |line|
      word_form, lemma, info = line.split(' ')
      info = msd.parse(info, language)
      data << {
        word_form: word_form,
        lemma: lemma,
        info: info
      }
    end
  end

  def lemma(word_form)
    @data.each do |ele|
      return ele[:lemma] if ele[:word_form] == word_form
    end

    return nil
  end

  def forms(lemma)
    @data.find_all do |ele|
      ele[:lemma] == lemma
    end
  end
end

require "#{File.dirname(__FILE__)}/multext/msd"

