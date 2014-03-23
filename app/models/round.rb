class Round < ActiveRecord::Base
  belongs_to :game
  
  def after_initialize
    @scores = []
  end

  def after_initialize_letter
    @letter
  end
  
  def random_letter_die
    alphabet = ("a".."z").to_a
    unused_letters = ["q", "u", "v", "x", "y", "z"]
    @random_letter = alphabet - unused_letters
    self.after_initialize_letter
    $letter = @random_letter.sample
  end

  # def set_letter(round_letter)
  #   # @letter = round_letter
  #   self.letter = round_letter
  # end

  def letter
    @letter
  end


  def auto_reject(answers)
    self.after_initialize
    (0..11).each do |key|
      if answers[key.to_s] == "" || answers[key.to_s].first != $letter
        self.set_scores(key, 0)
      else
        self.set_scores(key, 1)
      end
    end
    self.scores
  end

  def set_scores(index, score)
    self.scores[index] = score
  end

  def scores
    @scores
  end

  def pick_category
    @pick_category = $redis.smembers("all_categories").sample
    
    return $redis.smembers(@pick_category)
  end

  
end