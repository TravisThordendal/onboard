require 'openssl'

module OpenSSL
  module X509
    class Certificate
      def to_h
        # TODO? metaprogramming DRY?
        
        # just sugar
        h = {
          'not_before'          => not_before(),
          'not_after'           => not_after(),
          'serial'              => serial().to_i,
          'version'             => version() + 1, # X509 version 0x02 -> 3 etc..
          'signature_algorithm' => signature_algorithm()
        }

        # less trivial part
        issuer_h = {}
        issuer.to_a.each do |elem|
          if elem[1].encoding == Encoding::ASCII_8BIT
            elem[1].force_encoding 'utf-8'
          end # lacking info on a raw byte sequence, utf8 encoding is assumed
          issuer_h[elem[0]] = elem[1] # we loose elem[2] (numeric 'type')
        end        
        h['issuer'] = issuer_h

        subject_h = {}
        subject.to_a.each do |elem|
          if elem[1].encoding == Encoding::ASCII_8BIT
            elem[1].force_encoding 'utf-8'
          end # lacking info on a raw byte sequence, utf8 encoding is assumed
          subject_h[elem[0]] = elem[1] # we loose elem[2] (numeric 'type')
        end        
        h['subject'] = subject_h

        return h
      end
    end
  end
end