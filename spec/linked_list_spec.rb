# frozen_string_literal: true

RSpec.describe LinkedList do
  it 'has a version number' do
    expect(LinkedList::VERSION).not_to be nil
  end

  let(:array) { [1, 3, 2, 5, 8] }
  let(:list) { LinkedList::List.from_array(array) }

  describe '#at' do
    let(:nth) { 0 }
    subject { list.at(nth) }
    context 'nth is 0' do
      let(:nth) { 0 }
      it { is_expected.to eq 1 }
    end
    context 'nth is 1' do
      let(:nth) { 1 }
      it { is_expected.to eq 3 }
    end
    context 'nth is 2' do
      let(:nth) { 2 }
      it { is_expected.to eq 2 }
    end
    context 'nth is 3' do
      let(:nth) { 3 }
      it { is_expected.to eq 5 }
    end
    context 'nth is 4' do
      let(:nth) { 4 }
      it { is_expected.to eq 8 }
    end
    context 'nth is 5' do
      let(:nth) { 5 }
      it { is_expected.to eq nil }
    end
    context 'nth is -1' do
      let(:nth) { -1 }
      it { is_expected.to eq 8 }
    end
    context 'nth is -2' do
      let(:nth) { -2 }
      it { is_expected.to eq 5 }
    end
    context 'nth is -5' do
      let(:nth) { -5 }
      it { is_expected.to eq 1 }
    end
    context 'nth is -6' do
      let(:nth) { -6 }
      it { is_expected.to eq nil }
    end
  end

  describe '#first' do
    subject { list.first }
    it { is_expected.to eq 1 }
  end

  describe '#last' do
    subject { list.last }
    it { is_expected.to eq 8 }
  end

  describe '#length' do
    let(:list) { LinkedList::List.from_array(array) }
    subject { list.length }
    it { is_expected.to eq 5 }
  end

  describe '#append' do
    subject { -> { list.append(10) } }
    it { is_expected.to change { list.last }.from(8).to(10) }
  end

  describe '#insert' do
    let(:nth) { nil }
    subject { -> { list.insert(nth, 10) } }
    context 'exist index' do
      let(:nth) { 2 }
      it { is_expected.to change { list.at(nth) }.from(2).to(10) }
    end
    context 'not exist index' do
      let(:nth) { -10 }
      it { is_expected.to raise_error IndexError }
    end
  end

  describe '#clear' do
    subject { -> { list.clear } }
    it { is_expected.to change { list.first }.from(1).to(nil) }
  end

  describe '#delete_at' do
    subject { -> { list.delete_at(2) } }
    it { is_expected.to change { list.at(2) }.from(2).to(5) }
    it { is_expected.to change { list.length }.from(5).to(4) }
  end

  describe '#shift' do
    describe 'return' do
      subject { list.shift }
      it { is_expected.to eq 1 }
    end
    describe 'change' do
      subject { -> { list.shift } }
      it { is_expected.to change { list.length }.from(5).to(4) }
      it { is_expected.to change { list.first }.from(1).to(3) }
    end
  end

  describe '#unshift' do
    subject { -> { list.unshift(10) } }
    it { is_expected.to change { list.length }.from(5).to(6) }
    it { is_expected.to change { list.first }.from(1).to(10) }
    it { is_expected.to change { list.at(1) }.from(3).to(1) }
  end
end
