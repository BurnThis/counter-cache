module Counter
  module Cache
    class ActiveRecordReader < Struct.new(:record, :attr)
      def get
        return current_column_value + counter_value.to_i if counter_value
        current_column_value
      end

      private

      def current_column_value
        record.send("#{attr}").to_i
      end

      def counter_value
        counting_data_store.get(key)
      end
      
      def key
        "cc:#{record.class.to_s[0..1]}:#{record.id}:#{column}"
      end
      
      def column
        attr.to_s.gsub(/_count/, '')
      end

      def counting_data_store
        Counter::Cache.configuration.counting_data_store
      end
    end
  end
end
