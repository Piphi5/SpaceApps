import json
import random
import unittest
from ImagesAPIReader import imgapi

class QuestionGen:
    question_words = {
    "type of mars landmark is" : ["mountain", "lake", "crater", "glacier", "volcano"],
    "type of galaxy is" : ["spiral", "round", "something", "test", "somethingee"],
    "planet is in" : ["Earth", "Mars", "Saturn", "venus", "mercury"],
    "type of space landmark is" : ["Nebula", "Supernova", "blackhole", "dwarf star", "neutron star"],
    }
    num_choices = 4
    _question = {}
    def gen_question(self):
        question_structure = "What {category} the image above?"
        
        # question generation
        category, choices = random.choice(list(self.question_words.items()))
        answer = random.choice(choices)
        self._question = {"question": question_structure.format(category = category),
                    "choices" : random.sample(choices, self.num_choices),
                    "answer" : answer,
                    "image" : imgapi(answer)
        }
        return self._question
    def _valid_question(self):
        if self._question:
            return True
        else:
            raise Exception("Please generate a question first")
    def get_question(self):
        if self._valid_question():
            return self._question["question"]
    def get_answer(self):
        if self._valid_question():
            return self._question["answer"]
    def get_img(self):
        if self._valid_question():
            return self._question["image"]
    def get_choices(self):
        if self._valid_question():
            return self._question["choices"]
    def get_json(self):
        if self._valid_question():
            return json.dumps(self._question)
        
if __name__ == '__main__':
    gen = QuestionGen()
    gen.gen_question()
    print(gen.get_question())
    print(gen.get_choices())
    print(gen.get_answer())
    print(gen.get_img())
    print(gen.get_json())
