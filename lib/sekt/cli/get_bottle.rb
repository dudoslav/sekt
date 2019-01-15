module Sekt
  module CLI
    module GetBottle
      def get_bottle!(id)
        @cellar ||= Cellar.new
        bottle = @cellar.get_bottle(id)
        raise "Failed to find bottle: #{id}" unless bottle
        return bottle
      end
    end
  end
end
