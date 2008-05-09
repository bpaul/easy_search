module RPH
  module EasySearch
    class Validations
      # called once the EasySearch module is included.
      #
      # it ensures that any/all models in the settings hash exist
      # and decend from ActiveRecord::Base
      def self.validate_settings!
        unless Setup.settings.blank?
          Setup.settings.keys.each do |klass|
            unless klass.to_s.singularize.classify.constantize.descends_from_active_record?
              raise( InvalidActiveRecordModel, InvalidActiveRecordModel.message )
            end
          end
        end
      rescue NameError
        raise( NoModelError, "you've specified a table in your `Setup.config' block that doesn't exist" )
      end
      
      # called when a new EasySearch containing class is instantiated.
      #
      # For example, `Search.users.with("ryan heath")' would instantiate a
      # new Search, setting the "users" part to the @klass variable.
      # the following would ensure that the @klass variable is indeed valid.
      def self.validate_class!(klass)
        raise( InvalidActiveRecordModel, InvalidActiveRecordModel.message ) unless valid_model?(klass)
    	  raise( InvalidSettings, InvalidSettings.message ) unless model_has_settings?(klass)
      end
    	
    	private
    	  def self.valid_model?(klass)
      	  klass.to_s.singularize.classify.constantize.descends_from_active_record?# rescue false
      	end
    	
      	def self.model_has_settings?(klass)
      	  !Setup.settings[klass].blank? rescue false
      	end
    end
  end
end