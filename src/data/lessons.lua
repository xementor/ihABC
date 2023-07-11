local M = {}

function M.generatorLesson(ballText, ballWord)
  local lesson = {}
  lesson.ballText = ballText
  lesson.ballWord = ballWord
  -- ballText = { "D", "E", "F" },
  -- ballWord = { "", "Doll", "Eagle", "Food" },

  function lesson.getTargetWord(i)
    return lesson.ballWord[i]
  end

  function lesson.getTargetText(i)
    return lesson.ballText[i]
  end

  return lesson
end

return M
