require 'rails_helper'

RSpec.describe MembersController, type: :controller do

  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'

    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user                  = FactoryBot.create(:user)
    @current_user.confirm

    sign_in @current_user
  end

  describe "POST #create" do
    context "user is allowed to create member" do
      before(:each) do
        @current_campaign = FactoryBot.create(:campaign, user: @current_user)
      end

      context "with right attributes" do
        before(:each) do
          @member_attributes = attributes_for(:member, campaign_id: @current_campaign.id)

          post :create, params: { member: @member_attributes }
        end

        context "a new member" do
          it "returns success status" do
            expect(response).to have_http_status(200)
          end

          it "create member with right attributes" do
            expect(Member.last.name).to     eql(@member_attributes[:name])
            expect(Member.last.email).to    eql(@member_attributes[:email])
            expect(Member.last.campaign).to eql(@current_campaign)
          end
        end
      end
    end

  end

  describe "DELETE #destroy" do
    context "user is allowed to delete a member" do
      before(:each) do
        @current_campaign = FactoryBot.create(:campaign, user: @current_user)
      end

      context "with a member exist in the campaign" do
        it "returns success status" do
          member = create(:member, campaign: @current_campaign)

          delete :destroy, params: { id: member.id }

          expect(response).to have_http_status(:success)
        end
      end
    end
  end

end
