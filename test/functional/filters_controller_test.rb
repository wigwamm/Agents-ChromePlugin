require 'test_helper'

class FiltersControllerTest < ActionController::TestCase
  setup do
    @filter = filters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filter" do
    assert_difference('Filter.count') do
      post :create, filter: { agents: @filter.agents, areas: @filter.areas, max_bedrooms: @filter.max_bedrooms, max_price: @filter.max_price, min_bedrooms: @filter.min_bedrooms, min_price: @filter.min_price, name: @filter.name, type: @filter.type }
    end

    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should show filter" do
    get :show, id: @filter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @filter
    assert_response :success
  end

  test "should update filter" do
    put :update, id: @filter, filter: { agents: @filter.agents, areas: @filter.areas, max_bedrooms: @filter.max_bedrooms, max_price: @filter.max_price, min_bedrooms: @filter.min_bedrooms, min_price: @filter.min_price, name: @filter.name, type: @filter.type }
    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should destroy filter" do
    assert_difference('Filter.count', -1) do
      delete :destroy, id: @filter
    end

    assert_redirected_to filters_path
  end
end
