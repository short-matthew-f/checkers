module CheckersErrors
  class InvalidSequenceError < StandardError
    def message
      "Your piece can't follow your path."
    end
  end
  
  class NotYourPieceError < StandardError
    def message
      "That's not your piece!"
    end
  end
  
  class WhatDidYouTypeError < StandardError
    def message
      "Please try to type the correct thing, eh?"
    end
  end
end