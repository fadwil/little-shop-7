require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do
  before do
    visit "/admin"
  end

  it 'exists with header' do
    expect(page).to have_content('Admin Dashboard')
  end

  it 'has links to the admin merchants and invoices index' do
    expect(page).to have_link("Merchants", href: "/admin/merchants")
    expect(page).to have_link("Invoices", href: "/admin/invoices")
  end

  xit 'displays the names of the top 5 customers with purchase amounts' do
    expect(page).to have_content("Top Customers")
    expect()
  end

end