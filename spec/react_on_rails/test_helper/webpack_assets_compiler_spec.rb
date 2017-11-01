# frozen_string_literal: true

require_relative "../spec_helper"

describe ReactOnRails::TestHelper::WebpackAssetsCompiler do
  describe "#ensureAssetsCompiled" do
    let(:invalid_command) { "sh -c 'exit 1'" }
    context "when assets compiler command is invalid" do
      before do
        allow(ReactOnRails.configuration)
          .to receive(:build_test_command)
          .and_return(invalid_command)
      end

      it "exits immediately" do
        puts "\n\nBEGIN IGNORE PRINTS IN THIS TEST"
        expect do
          ReactOnRails::TestHelper::WebpackAssetsCompiler.new.compile_assets
        end.to raise_error(SystemExit)
        puts "END IGNORE PRINTS IN THIS TEST\n\n"
      end

      it "prints the correct message" do
        expected_output = <<-MSG.strip_heredoc
          React on Rails FATAL ERROR!
          Error in building webpack assets!
          cmd: cd #{Rails.root} && #{invalid_command}
        MSG

        expect do
          begin
            ReactOnRails::TestHelper::WebpackAssetsCompiler.new.compile_assets
            # rubocop:disable Lint/HandleExceptions
          rescue SystemExit
            # No op
          end
          # rubocop:enable Lint/HandleExceptions
        end.to output(/#{expected_output}/).to_stdout
      end
    end
  end
end
