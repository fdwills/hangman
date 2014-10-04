require 'subanalysiser/base'
require 'libsvm'

module HangMan
  module SubAnalysiser
    class SvmAnalysiser < Base

      SAMPLE_NUMBER = 400000
      MODEL_FILE = 'lib/model/svm.model'
      TRAIN_FILE = 'lib/model/svm.train'

      def analysis(source, svm_source: nil)
        puts "Analysis(svm training will cost long time)............"

        # [[array, -1/1], ...]
        training_set = generate_training_set(svm_source)

        examples = []
        labels = []
        training_set.each do |data, label|
          examples << Libsvm::Node.features(*data)
          labels << label
        end

        problem = Libsvm::Problem.new
        problem.set_examples(labels, examples)

        parameter = Libsvm::SvmParameter.new
        parameter.cache_size = 10
        parameter.eps = 0.0001
        parameter.c = 10
        parameter.probability = 1
        parameter.kernel_type = Libsvm::KernelType.const_get(:RBF)

        model = Libsvm::Model.train(problem, parameter)
        model.save(MODEL_FILE)
      end

      def load
        @probility_model = Libsvm::Model.load(MODEL_FILE)
      end

      def predict(word, candidate)
        sample = []
        sample << word.size
        ("a".."z").to_a.each do |char|
          if word.include?(char)
            sample << 1
          elsif candidate.include?(char)
            sample << 0
          else
            sample << -1
          end
        end

        candidate.inject({}) do |r, char|
          sample_copy = sample
          sample_copy[char.ord - 'a'.ord + 1] = 1
          result_label, result_probility = self.probility_model.predict_probability(Libsvm::Node.features(*sample_copy))
          r[char] = result_probility[0]
          r
        end
      end

      private

      # to [[feature ,label], ...]
      def generate_training_set(source)
        data = []

        f = open(source, 'r')
        f.each_with_index do |line, index|
          word = line.chomp
          origin, guessed, feedback = word.split("\t")

          if origin == feedback
              data << [to_sample(JSON.parse(guessed), feedback), -1]
          else
              data << [to_sample(JSON.parse(guessed), feedback), 1]
          end
          break if index > SAMPLE_NUMBER
        end
        f.close

        open(TRAIN_FILE, "w") do |f|
          YAML.dump(data,f)
        end

        data
      end

      # to [size, 0/1/-1, ... ]
      def to_sample(guessed, feedback)
        sample = []
        sample << feedback.size

        ("a".."z").to_a.each do |char|
          if guessed.include?(char) && feedback.include?(char)
            sample << 1
          elsif guessed.include?(char)
            sample << -1
          else
            sample << 0
          end
        end
        sample
      end
    end
  end
end
