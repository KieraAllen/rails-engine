require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  it 'can create a new merchant' do
    merchant_params = ({ name: 'Bonanza Building' })

    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/merchants', headers: headers, params: JSON.generate(merchant: merchant_params)

    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'can update an existing merchant' do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: 'Bonanza Building Co'}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})

    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq('Bonanza Building Co')
  end

  it 'can destroy a merchant' do
    merchant = create(:merchant)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
